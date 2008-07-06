{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "file-4.25";
  src = fetchurl {
    url = ftp://ftp.astron.com/pub/file/file-4.25.tar.gz;
    sha256 = "abcd5bc7f9a604b5966463eac4a3f54de180a08adb513d902bb44152ebad6c8a";
  };

  meta = {
    description = "A program that shows the type of files";
    homepage = ftp://ftp.astron.com/pub/file;
  };
}
