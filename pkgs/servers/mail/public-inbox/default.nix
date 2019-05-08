{ stdenv, fetchgit, perlPackages, git, xapian }:

with perlPackages;
buildPerlPackage rec {
  pname = "public-inbox";
  version = "5a4caaca8f";

  src = fetchgit {
    url = "https://public-inbox.org";
    rev = "5a4caaca8f52799844d0baf93b8c2595edb04f2b";
    sha256 = "1gk02nz65xh0a7p517qabdlliw5r5lxz4bj4in624hkwg6mh44ah";
  };
  patches = [
    ./spawn-test.patch
    ./shared.patch
  ];
  checkInputs = [ TestHTTPServerSimple IPCRun ];
  # many commands use git binaries, and public-inbox-compact uses xapian-compact
  propagatedBuildInputs = [ git xapian.out ];
  buildInputs = [ TimeDate EmailMIME EmailMIMEContentType Encode
  Plack URI IOCompress DBI DBDSQLite NetServer FilesysNotifySimple
  PlackMiddlewareReverseProxy PlackMiddlewareDeflater SearchXapian
  DangaSocket
  # InlineC is used *at runtime* to compile some acceleration parts.
  # TODO we should add an option upstream to use InlineC at build
  # time instead
  InlineC
  ];
}
