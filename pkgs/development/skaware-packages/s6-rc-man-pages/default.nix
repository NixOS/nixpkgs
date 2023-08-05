{ lib, buildManPages }:

buildManPages {
  pname = "s6-rc-man-pages";
  version = "0.5.4.1.2";
  sha256 = "Ywke3FG/xhhUd934auDB+iFRDCvy8IJs6IkirP6O/As=";
  description = "mdoc(7) versions of the documentation for the s6-rc service manager";
  maintainers = [ lib.maintainers.qyliss ];
}
