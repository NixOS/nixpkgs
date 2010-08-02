{
  downloadPage = "http://code.google.com/p/redstore/downloads/list";
  baseName = "redstore";
  choiceCommand = '' head -n 1 | 
   sed -re "s@[&].*@@; s@.*[?]name=(.*)@http://$(sed -re "s@.*/p/([^/]+)/.*@\\1@" <<< "$(getAttr downloadPage)").googlecode.com/files/\\1@" '';
}
