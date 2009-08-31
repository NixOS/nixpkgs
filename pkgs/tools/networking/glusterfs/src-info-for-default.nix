{
  downloadPage = "http://ftp.gluster.com/pub/gluster/glusterfs/2.0/";
  sourceRegexp = "^2[.]0[.]";
  choiceCommand = ''tail -1 | sed -re 's@(.*)/@&glusterfs-\1.tar.gz@' '';
  baseName = "glusterfs";
}
