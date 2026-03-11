#set page("a4", flipped: true, columns: 3, margin: 0.5cm)
#set columns(gutter: 0.25cm)
#set text(font: "Noto Sans", size: 10pt)
#set par(leading: 0.15cm, spacing: 0.2cm)

#let module(body) = {
    set text(weight: "bold", fill: blue)
    [#body --- ]
}

#let keyword(body) = {
    set text(style: "italic", fill: fuchsia)
    [#body]
}
#let num = [n#box(stack(
    dir: ttb,
    spacing: 1pt,
    text(size: 0.6em)[o],
    line(length: 0.35em, stroke: 0.6pt),
    v(0.3em)
))
]

#module[Malware]
#keyword[APTs]: Advanced Persistent Threats. Targeted at high-value victims,
specific, complex. Avoid detection, exploit over time.
#keyword[Botnet]: botmaster controls bots via C&C server. Sophisticated C&C
architectures: peer-to-peer, hierarchical, star. Encrypted, botmaster server
changes IP often. Goals: data theft, spam, DDOS, credential stuffing, network
scanning....
#keyword[Honeypots]: intentionally vulnerable machines to attract & analyse
malware. Can be hard to trigger malicious behaviour, 16% malware detects
virtualisation.
#keyword[Malware detection]: extract static/dynamic *signatures*. Evasion:
metamorphic malware, crypting services, mix legit behaviour in.

#module[Threat Modelling]
#keyword[Data-flow diagrams]: depict data flow across system components. Trust
boundaries establish what _principal_ controls what. Rect = entity,
rounded rect = process, arrow = data flow, dotted rect = trust boundary,
two-line rect = data store.
#keyword[STRIDE]: thread modelling. Spoofing, Tampering, Repuditaion (denying
having done smth), Information disclosure, Denial of service, Elevation of
privilege.
#keyword[Attack trees]: root is goal of attack. Children are steps to achieve
goal. Leaves are concrete attacks. Siblings are step 1 *or* step 2. Join
sibling lines with arc for step 1 *and* step 2. Textual notation: tree depth
represented by tab, prefix child with + for *and*, - for *or*.
#keyword[DREAD]: threat eval. Score each threat between 5 and 15. For each
DREAD category score 3, 2 or 1. Damage potential, Reproucibility,
Exploitability, Affected users, Discoverability.
#keyword[META]: threat response. Mitigate, Eliminate, Transfer, Accept.

#module[Authentication]
#keyword[Salted hash]: mitigate offline dictionary attack. Can still build
targeted dictionary for one user.
#keyword[Linux password file]: `username:password-data:params`. Password data:
`$hash-fun-id$salt$passwd`, `*` = disabled. Parameters: config passwd expiry.
#keyword[Honeypot passwords]: create fake account with easy uname & passwd,
block requests from hosts that log into those accounts.

#module[Pentesting]
#keyword[Black|grey|white box]: no|some|all information/code.
#keyword[PTES]: Pentesting execution standard. 1. pre-engagement (sign
contract), 2. intelligence gathering, 3. threat modelling, 4. vulnerability
analysis, 5. exploitation, 6. post-exploitation, 7. report.
#keyword[Google hacking]: `ext:pdf`, `site:example.com`, `inurl:html`,
`intitle:index.of "parent directory"`, `allintext: "Powered by phpbb"`, `inurl:
index.asp`.
#keyword[Cache search]: use proxy/cache to prevent accessing target.
#keyword[*Active* information gathering]: `dig`, send emails and watch for
bounce, `traceroute`, host discovery, port scanning, OS fingerprinting.
#keyword[Exploitation]: publicly-available exploits at www.exploit-db.com

#module[LAN Security]
#keyword[MAC flooding/Switch poisoning]: switch has CAM table associating MAC
to port. Flood switch with invalid MACs to fill CAM cache. Forces switch to
broadcast packets on cache miss. Countermeasure: whitelist MACs.
#keyword[Becoming MITM]: spoof MAC of router + MAC flood to exclude router from
cache. #keyword[ARP spoof]: attacker replies to ARP request with its own MAC.
If attacker reply cached by host, MITM. Counter: assign router MAC statically,
detect concurrent replies to ARP query.

#module[IP Security]
#keyword[MANRS]: Mutually Agreed Norms for Routing Security. Best practices to
secure BGP. Use RPKI to propagate trust down internet address hierarchy.
Provide certificate proving ownership of prefix/subnet.
#keyword[IPsec]: add #keyword[authentication header] (AH) &
#keyword[encapsulating security payload] (ESP). AH: auth + integrity of entire
packet, doesn't work with NAT. ESP: confidentiality of payload. IPsec modes:
*transport* (protect payload only) & *tunnel* (also header). ESP tunnel mode
used to implement VPNs. Original packet gets wrapped + encrypted in new IP
packet using `ESP` transport protocol.
#keyword[TCP session hijacking]: MITM can read seq #num & inject packets.
Off-path attacker can guess seq #num. Counter: layer 5 encryption, IDS.
#keyword[TCP idle scan]: find idle host. SYN it to get IPID. Spoof its IP to
SYN target. Check IPID on idle host again. $x+1$ #sym.arrow.r port closed,
$x+2$ #sym.arrow.r port closed.
#keyword[UDP scans]: send generic UDP header with no payload. Response
#sym.arrow.r port open, ICMP error #sym.arrow.r closed/filtered by firewall,
timeout #sym.arrow.r filtered or open but service drops ill-formed packets, so
try with protocol-specific payload.
#keyword[Port knocking]: only host that scans sequence of ports first can
access port.

#module[Network Defences]
#keyword[Main firewall] protects *all* internet traffic, internal net kept
separate from #keyword[DMZ] (outward services), IDSs at different points to
detect attacks.
#keyword[IDS]: more powerful than firewall, _deep packet inspection_.
Approaches: signature based, anomaly-detection based, specification based
(apply logic rules).
#keyword[Signature-based]: mostly human-generated, easy to bypass, expensive;
false-pos under bandwidth stress.
#keyword[IDS evasion]: Use traceroute to find IDS. Send middle fragment that is
seen by IDS but expires before reaching target. IDS sees different payload.
#keyword[Anomaly detection]: report statistical anomalies. Can catch new
attacks. Suffers false-pos. Anomaly types: point, contextual, collective.
Models: classification (Bayesian, neural nets), statistical (histograms, PCA,
regression).

#module[DNS]
#keyword[DNSSEC]: protect *authenticity* and *integrity* of DNS records. DNSSEC
chain of trust follows DNS resolution path, starting at DNS root. Parent node
uses private key to sign hashes of children's public keys. DNS resolution node
signs zone data using private key.
#keyword[Zone enumeration]: NSEC record reveals alphabetically closest
neighbours. NSEC3 returns salted hash of nearest names.
#keyword[DNS tunneling]: bypass firewall/proxy by encoding data in DNS query.
#keyword[Malicious domans]: cybersquatting, typosquatting, bitsquatting,
dropcatching.

#module[TLS] public key cryptography, protects only TCP payload.
#keyword[TLS certificates]: TLS client trusts known CAs. TLS server sends
certificate chain so client verifies ownership of public key.
#keyword[TLS handshake]: establish ciphersuite, compression, extensions.
#keyword[Server name indication] (SNI): TLS extension to allow client to
specify requested domain name (CDNs have several sites under one IP). This
prevents large certificates listing every hosted website on the CDN.
#keyword[Certificate validation]: _extended validation_ (EV) in-person/phone,
thorough. _Domain validation_ (DV): common, domain owner proves control by
placing random token in DNS record, or at a URL, or sent from CA in email.
#keyword[Mitigating rogue certs]: all issued certs report in public logs so
real domain owners can detect rogue.
#keyword[DANE]: rely on DNSSEC to control trust in TLS certificates, domain
owner can deploy self-signed certs, trust moves from CAs to DNS operators. TLSA
DNS record stores hash of certificate that client can compare with.
#keyword[TLS issues]: traffic analysis, implementaiton bugs.
#keyword[TLS 1.3]: more efficient than 1.2, uses less RTs to establish, 0 RTs
to resume with TCP fast open (TFO). Weak ciphersuites & compression banned.
ClientHello includes public key, rest of handshake encrypted. ESNI optional.
Makes passive proxies impossible, as server certificate cannot be sniffed.

#module[HTTP]
#keyword[Response codes]: 2xx success, 3xx redirection, 4xx client error, 5xx
server error. Rare response codes used for #keyword[C2] to evade IDS.
Security issues: #keyword[HTTP proxy cache poison], #keyword[response
splitting]: client accepts bogus responses over keepalive connection,
#keyword[DNS spoofing].
#keyword[HTTPS drawbacks]: ISPs cannot cache HTTPS traffic, ISDs have limited
visibility.
#keyword[SSL stripping]: MITM accepts HTTP connection and acts as proxy to
HTTPS server. Countermeasure: HTTP header `Strict-Transport-Security` says load
pages from that domain only over HTTPS in future. For first connection,
browsers have list of websites that must be https (not scalable), or DANE can
associate HSTS to DNSSEC.
#keyword[Referrer header] leaks info; put sensitive data in POST body, use
`Referrer-Policy: no-referrer|origin|same-origin|...`
#keyword[DoH]: DNS over HTTPS. Provides integrity and confidentiality to DNS
queries. DoT (DNS over TLS) too.

#module[Server-side Security]
Architectures: #keyword[CGI scripts], #keyword[server-side script],
#keyword[fast CGI], #keyword[reverse proxy] (lean fast server handles static
content, TLS termination & directs to application server).
#keyword[Path traversal]: url input causes server to disclose unintended
resource. Counter: `www` user for server with access only to public files. Web
app process sandboxed with 'chroot jail'.
#keyword[Remote file inclusion]: get server to run malicious php. Counter:
whitelist of page names.
#keyword[Server-side request forgery]: attacker gets server to access a
resource, e.g. data exfiltration, port scanning. Counter: whitelist requests
server-side app can isuse.
#keyword[Command injection]: block forbidden patterns, whitelists, taint
analysis.
#keyword[Shellshock]: server copies http headers to env vars of bash to run CGI
script. Malformed header causes code exeuction.
#keyword[SQL injection]: `' OR '1' = '1`. Get schema:
`SELECT table_schema, table_name, column_name FROM information_schema.columns`,
using union: `UNION SELECT x,y,NULL from T`.
Counter: input filtering, prepared statements (language-level), stored
procedures, code analysis, IDS, programming framework.
`mysql_real_escape_string($str)` in PHP.

#module[Browser Security]
#keyword[Phishing] counters: prevent spam, blacklist known phishing sites,
automated ML classifier.
#keyword[PostMessage]: communicate string data between frames, sender can
specify destination origin.
#keyword[Clickjacking] counters: `X-Frame-Options` header (can page be
iframed), frame-busting JS `if (self != top) top.location = self.location`.
#keyword[Drive-by download]: malicious page exploits vulnerability to install
malware on client. Counter: disable plugins, blacklists, IDS.
#keyword[Content sniffing]: browser can render based on data not MIME type.
#keyword[Polyglot]: files valid wrt different data formats. Counter:
`X-Content-Type-Options: nosniff` response header.
#keyword[WebAuthn]: W3C standard for passwordless auth. Implemented by
#keyword[passkeys]. WebAuthn credentials generated by OS. Share across devices
by scanning QR code.

#module[Same Origin Policy]
Origin defined by (scheme, host, port, domain).
Pages in different browsing contexts + persistent resources can only be
accessed by the same origin.
#keyword[DNS rebinding]: Initial DNS query yields real IP with short TTL. User
downloads script, which makes a second request to website. DNS re-queries,
yields IP addr in internal network. Counter: DNS pinning (bindings cannot
change quickly), prevent external DNS queries resolving to internal addresses.
#keyword[Domain relaxation]: deprecated `document.domain = "example.com"`.

#module[Scripting attacks]
#keyword[DOM-based]: client-side.
#keyword[Reflected]: server-side.
#keyword[Stored]: data stored on server, later embedded on a page.
#keyword[XSS counters]: `htmlspecialchars($str)` in PHP
Valid suffixes in #keyword[Public Suffix List], `X-XSS-Protection: 1`,
`Content-Security-Policy` headers.
#keyword[Self-XSS]: trick user into running JS.
#keyword[XCS]: cross-channel scripting. Inject XSS payload using non-HTTP
channel (e.g. SMB file name), triggered when user loads admin page.
#keyword[Universal XSS]: extension/chrome has XSS vulnerability that gives
access to *any* page.
#keyword[Scriptless]: even if JS is turned off, injected CSS can exfiltrate
page data.
#keyword[Source code snooping]: counter: hide state inside closures.
#keyword[Prototype poisoning]: `Object.prototype.field = `, alters expected
behaviour of JS code. Counter: check types (avoid implicit conversion), avoid
inheritance, use shadow properties.
#keyword[HTML5 sandbox]: `sandbox` attribute for iframes. Assigns unique origin
to iframe & all active behaviour prevented by default. Can choose allowed
behaviour.
#keyword[CSP]: Content Security Policy. Response header whitelisting where
resources can be loaded from. Can set `sandbox` attr of iframes.

#module[Browser Storage]
#keyword[Cookies]: set with `Set-Cookie: name=value[;attributes]*`. Browser
includes cookies in subsequent requests: `Cookie: (name = val;)+`.
#keyword[Cookie attributes]: domain (suffix not in Public Suffix List, defaults
to host URL), path, expires, secure (HTTPS-only), HttpOnly (stops non-HTTP
access, e.g. JS), SameSite.
#keyword[JS access] via `document.cookie`.
#keyword[Cookie origin]: (domain, path). Cookie identified by name + origin.
#keyword[Security considerations]: server doesn't see cookie attributes; path
does not restrict visibility of cookies (path is for efficiency), page could
load iframe of different path and access cookies using SOP; cookie integrity
not guaranteed.
#keyword[Web storage]: `window.localStorage` (page origin) or
`window.sessionStorage` (current tab + page origin).
#keyword[Resident XSS]: DOM-based variant; set browser storage to malicious
value. Can remain effective after page is patched.

#module[Secure Sessions]
#keyword[HTTP digest auth]: send passwd hash + server-generated nonce.
Inefficient to authenticate for every asset.
#keyword[Session fixation]: attacker tricks user to authenticate using their
token. Counter: after login, issue new token.
#keyword[Session hijacking]: attacker steals valid token. Counter: use HTTPS,
invalidate session after logout, use secure tokens.
#keyword[Secure tokens]: stop spoofing by making tokens unpredictable. Stop
stealing by binding session to client context (IP, SSL session ID, browser
fingerprint). E.g. session data = (timestamp, random val, user id, login
status, client context). Either: server keeps data (small token = hash(data),
db lookup for every request) or server sends data to client (larger token,
server must still track login status).
#keyword[CSRF]: trick user into performing action they are auth'd for.
#keyword[CSRF SOHO]: JS forces device to change router's DNS resolver to
malicious one. Counter: use POST not GET, double cookie (server sends csrf
token as cookie, client sends it with reqst as hidden form field or custom
header, server injects random token (or hash) as hidden field in form and
checks this matches, use `SameSite` attribute for session cookie (then cannot
access site via external link).
#keyword[CORS]: Cross Origin Resource Sharing, relaxes SOP for servers that opt
in. Browser attaches `Origin=` for cross-origin AJAX requests. If server
accepts cross-domain requests from that origin, replies with
`Access-Control-Allow-Origin: origin`. If server ignores CORS, browser discards
repsonse.
#keyword[BrowserAudit]: automated testing framework for SOP, CSP, CORS, ...
#keyword[Login CSRF]: trick user to login as attacker. Anti-CSRF token doesn't
apply (no session token before login). Counter: validate `referer` or `origin`
header of login request (but these can be stripped), embed login form on
dedicated page.

#module[Browser Fingerprinting]
passive (headers) or active (use JS, check fonts, performance). Counters: leak
min config info (degrades UX), mimic different target, hide in the crowd (use
common fingerprint), destabilise fingerprint (changes for every request).
Anti-fingerprinting is fingerprintable.

#module[Web Tracking]
#keyword[1st party]: script in page that has access to domain's cookies.
#keyword[3rd party]: iframe that has access to other domain's cookies.
#keyword[Cached resources]: server tells browser to cache a script, can save
state which can be loaded by other pages. Change resource name to force cache
miss.
#keyword[Supercookies]: using local storage for cookies.
#keyword[Cache headers]: `ETag` intended for cache validation, sent by browser
to server every time. Can be used as cookie.
#keyword[W3C Beacons] allows asynchronous logging that doesn't get cancelled
when tab is closed.
#keyword[Zombie cookies]: cookies can be respawned with tracking data in cache,
local storage, flash cookies or _fingerprinting_.
#keyword[Tracking counters]: do not track header, referrer-policy to prevent
cross-domain referer leaks, private browsing, anti-tracking extensions,
privacy-focussed browsers.
#keyword[Browser-based counters]: block 3rd party cookies (3rd party iframe
could open popup which is now 1st party cookie setter), disable plugins,
disable JS.
#keyword[Research]: automatically populate tracking blacklists, use ML to
identify trackers.
