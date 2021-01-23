import asyncdispatch, ssh2, ssh2/sftp

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
  var sftp = client.initSFTPClient()
  let entries = await sftp.dir("/")
  for entry in entries:
    echo entry
  await sftp.get("/readme.txt", "tmp_sftp_readme.txt")

  sftp.close()

waitFor main()

