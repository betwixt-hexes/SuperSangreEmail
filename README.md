SuperSangreEmail
================

For all^h^hsome of your super cPanel w/ Exim server needs.

Usage
--------------

**# wget https://raw.githubusercontent.com/batsyphus/SuperSangreEmail/master/sse.pl; chmod +x sse.pl**

**# ./sse.pl [OPTIONS]**

**Current Checks Impliemented:**

- Print current exim queue.
- Check for custom /etc/mailips and /etc/mailhelo.

**[With --domain option]**

- Check if domain is identical to hostname.
- Check if domain is in remote or local domains.
- Check if domain resolves locally to server.

**COMING SOON(ish):**

*Next push should aim to haz:*

- MOAR Readability (PRETTY COLORS)
- Check for /etc/userdomains
- *At LEAST* the e-mail option with, Iunno, one check?  Two maybe?

*And then I'm gonna...:*

- Probably start trying to switch to IPC::Run instead of that gigantor and likely unneccesary run() sub I ganked from SSP.
- Get port checks knocked out -- those look easy.
- Write a better dig statement for that resolve check.  That probably wasn't the best implimentation of that idea >.>.
- Cry forever.
