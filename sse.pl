#!/usr/bin/perl

use warnings;
use Sys::Hostname;
use Getopt::Long;
use Term::ANSIColor qw(:constants);
use POSIX;
use File::Find;
use Data::Dump 'dump';

$ENV{'PATH'} = '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin';

## OPTIONS ##

my $domain = '';
GetOptions ('domain=s' => \$domain);

## GLOBALS ##

my $hostname = hostname;
chomp (my $queue_cnt = `exim -bpc`);
my @local_ipaddrs_list = get_local_ipaddrs();
get_local_ipaddrs();

## GENERAL GUTS ## -- will run regardless of options passed.

print "There are currently $queue_cnt messages in the Exim queue.\n";
port_26();

custom_etc_mail();

## OPTIONED GUTS ##

if ($domain){ ## --domain
hostname_check();
domain_exist();
check_local_or_remote(); 
domain_resolv();
}

##INFORMATIONAL CHEX##

sub run {  #Directly ripped run() from SSP; likely more gratuitous than what is actually needed.  Remember to look into IPC::Run.

    my $cmdline = \@_;
    my $output;
    local ($/);
    my ( $pid, $prog_fh );
    if ( $pid = open( $prog_fh, '-|' ) ) {

    }
    else {
        open STDERR, '>', '/dev/null';
        ( $ENV{'PATH'} ) = $ENV{'PATH'} =~ m/(.*)/;
        exec(@$cmdline);
        exit(127);
    }

    if ( !$prog_fh || !$pid ) {
        $? = -1;
        return \$output;
    }
    $output = readline($prog_fh);
    close($prog_fh);
    return $output;
}

sub get_local_ipaddrs { ## Ripped from SSP as well.  Likely less gratuitous, but will likely drop the use of run() in the future cuz IPC.
    my @ifconfig = split /\n/, run( 'ifconfig', '-a' );
    for my $line (@ifconfig) {
        if ( $line =~ m{ (\d+\.\d+\.\d+\.\d+) }xms ) {
            my $ipaddr = $1;
            unless ( $ipaddr =~ m{ \A 127\. }xms ) {
                push @local_ipaddrs_list, $ipaddr;
            }
        }
    }
    return @local_ipaddrs_list;
}

### GENERAL CHEX ###

sub custom_etc_mail{
    if (-s '/etc/mailips') {
    print "/etc/mailips is NOT empty.\n";
    }
    if (-s '/etc/mailhelo') {
    print "/etc/mailhelo is NOT empty.\n";
    }
}
sub port_26 {  ## You'll need to remove the double /n as more checks are written.
if (`netstat -an | grep :26`) {
    print "Port 26 is ENABLED.\n\n";
    return;
}
else{
    print "Port 26 is DISABLED.\n\n";
}
}
### DOMAIN CHEX ###

sub hostname_check{
if ($hostname eq $domain){
    print "Your hostname $hostname appears to be the same as $domain.  Was this intentional?\n";
    }}

sub domain_exist {
open( USERDOMAINS, "/etc/userdomains" );
while (<USERDOMAINS>) {
    if (/^$domain: (\S+)/i) {
        my $user = $1;
        print "The domain $domain is owned by $user.\n";
        my $suspchk = "/var/cpanel/suspended/$user";
            if (-e $suspchk) {
                print "The user $user is SUSPENDED.\n";
            }
        return;
    }}
        print "The domain $domain DOES NOT exist on this server.\n";
close (USERDOMAINS);
}

sub check_local_or_remote {

open my $loc_domain, '<', '/etc/localdomains';
while (<$loc_domain>) {
    if (/^${domain}$/){
        print "$domain is in LOCALDOMAINS.\n";      
        }}
    close $loc_domain;

open my $remote_domain, '<', '/etc/remotedomains';
while (<$remote_domain>) {
    if (/^${domain}$/){
        print "$domain is in REMOTEDOMAINS.\n";
        last;
        }}
    close $remote_domain;
}

sub domain_resolv {
chomp($domain_ip = run('dig',$domain,'@8.8.4.4','+short'));
#foreach (@local_ipaddrs_list) {
#    if  (/^${domain_ip}$/) {
if (grep {$_ eq $domain_ip} @local_ipaddrs_list) {
        print "The domain $domain resolves to IP: $domain_ip.\n";
        return;
    }
    else {
        print "The domain $domain DOES NOT resolve to this server.\n";
        return; 
}

}
