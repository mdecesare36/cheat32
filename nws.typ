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

#module[HTTPS]

