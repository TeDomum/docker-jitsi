-- Prosody Configuration File

admins = { }
modules_enabled = {
	"disco"; -- Service discovery
	"private"; -- Private XML storage (for room bookmarks, etc.)
	"vcard"; -- Allow users to set vCards
	"version"; -- Replies to server version requests
	"uptime"; -- Report how long server has been running
	"time"; -- Let others know the time here on this server
	"ping"; -- Replies to XMPP pings with pongs
	"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
	"http_files"; -- Serve static files from a directory over HTTP
	"posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
};

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
	"offline"; -- Store offline messages
	"s2s"; -- Handle server-to-server connections
};

allow_registration = false;
daemonize = true;
pidfile = "/var/run/prosody/prosody.pid";
c2s_require_encryption = false
authentication = "internal_plain"

log = {
	-- Log files (change 'info' to 'debug' for debug logs):
	info = "/var/log/prosody/prosody.log";
	error = "/var/log/prosody/prosody.err";
	-- Syslog:
	{ levels = { "error" }; to = "syslog";  };
}

VirtualHost "{{ DOMAIN }}"
        -- enabled = false -- Remove this line to enable this host
        authentication = "anonymous"
        modules_enabled = {
            "bosh";
            "pubsub";
            "ping"; -- Enable mod_ping
        }

        c2s_require_encryption = false

Component "conference.{{ DOMAIN }}" "muc"
    storage = "null"
    --modules_enabled = { "token_verification" }
admins = { "focus@auth.{{ DOMAIN }}" }

Component "jitsi-videobridge.{{ DOMAIN }}"
    component_secret = "{{ JVB_SECRET }}"

VirtualHost "auth.{{ DOMAIN }}"
    authentication = "internal_plain"

Component "focus.{{ DOMAIN }}"
    component_secret = "{{ JICOFO_SECRET }}"
