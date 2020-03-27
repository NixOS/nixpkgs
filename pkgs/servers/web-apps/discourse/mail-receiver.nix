{ stdenv
, lib
, fetchFromGitHub
, ruby
, makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "mail-receiver";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "discourse";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "17rqvj0z5fy928wx0pmdnay89f24y0gjrj215bjpfy2lnf5n5h67";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  postPatch = ''
    substituteInPlace discourse-smtp-fast-rejection \
      --replace "require 'mail_receiver/fast_rejection'" \
                "require_relative '../lib/mail_receiver/fast_rejection'" \
      --replace "/etc/postfix/" \
                "/var/lib/discourse/"

    substituteInPlace receive-mail \
      --replace "require 'mail_receiver/discourse_mail_receiver'" \
                "require_relative '../lib/mail_receiver/discourse_mail_receiver'" \
      --replace "/etc/postfix/" \
                "/var/lib/discourse/"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a lib $out/
    cp discourse-smtp-fast-rejection receive-mail $out/bin
    wrapProgram $out/bin/discourse-smtp-fast-rejection --prefix PATH : ${ruby}/bin
    wrapProgram $out/bin/receive-mail --prefix PATH : ${ruby}/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/discourse/mail-receiver/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ sorki ];
    # XXX: this is not explicitely stated in repo, ask upstream
    license = licenses.gpl2;
    description = "Discourse mail receiver Postfix helpers";
  };
}
