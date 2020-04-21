{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-04-21";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "53fe1b18184fc0967658805abc8560641f8d2cb0";
    sha256 = "0rahj9v7cgvk4w3m41jbs8vnya37dhq5wxyhyg74kwrv8a2nqxra";
  };

  modSha256 = "0jn88a4hagwfkw9bv8cg12ywsg35znmfkmhi1v7k2qpj5qzi81w6";

  meta = with stdenv.lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
