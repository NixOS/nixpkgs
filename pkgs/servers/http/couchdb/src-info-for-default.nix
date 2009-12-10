{
  downloadPage = "http://couchdb.apache.org/downloads.html";
  baseName = "couchdb";
  choiceCommand = ''head -1 | sed -re "$skipRedirectApache" '';
  mirrorSedScript = ''$apacheMirror'';
}

