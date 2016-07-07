SuperSangreEmail
================

**This has been cloned to a new official home at: https://github.com/cPanelTechs/SSE**

For all^h^hsome of your super cPanel w/ Exim server needs.


**Current Checks Impliemented:**

- Print current exim queue.
- Check for custom /etc/mailips and /etc/mailhelo.
- Check if port 26 is enabled.
- Check if mail IPs are blacklisted
- Show reverse DNS for mail IPs

**[With --domain option]**

- Check if domain exists on the server.
- Check if the user account is suspended.
- Check if domain is identical to hostname.
- Check if domain is in remote or local domains.
- Check if domain resolves locally to server.

**COMING SOON(ish):**

*Next push should aim to haz:*

- *At LEAST* the e-mail option built in with, Iunno, one check?  Two maybe?
- IPTables chex.

*And then I'm gonna...:*

- IMPLIMENT COLORS.
- Probably start trying to switch to IPC::Run instead of that gigantor and likely unneccesary run() sub I ganked from SSP.
- Write a better dig statement for that resolve check.  That probably wasn't the best implimentation of that idea >.>.
- Cry forever more.
