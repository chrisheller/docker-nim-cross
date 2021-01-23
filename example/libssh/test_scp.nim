import asyncdispatch, ssh2, ssh2/scp

# Uses Rebex public test server to validate everything is working
proc main() {.async.} =
  let
    user = "demo"
    password = "password"
    host = "test.rebex.net"
    port = Port(22)

  var client = newSSHClient()
  defer: client.disconnect()
  await client.connect(host, user, port, password=password)

  let scp = client.initSCPClient()
  await scp.downloadFile("/readme.txt", "tmp_scp_readme.txt")

waitFor main()
