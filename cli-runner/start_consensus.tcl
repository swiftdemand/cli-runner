#!/usr/bin/expect -f

set wallet [lindex $argv 0]
set password [lindex $argv 1]

cd /var/lib/swift

exp_internal 1

spawn /usr/lib/swift/neo-cli /rpc

expect "neo>"

send "open wallet $wallet\n"

expect -timeout 200 {
	error {exit 1}
	timeout {exit 2}
	"File does not exist" {exit 3}
	password:
}

send "$password\n"

expect {
	failed {exit 4}
	cancelled {exit 5}
	timeout {exit 6}
	"neo>"
}

send "start consensus\n"
expect "OnStart"

expect -timeout -1 eof
