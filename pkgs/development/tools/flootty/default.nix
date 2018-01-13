{ stdenv, python }:

let
  inherit (python.pkgs) buildPythonApplication fetchPypi;
in

buildPythonApplication rec {
  pname = "Flootty";
  version = "3.2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vjwl6g1bwm6jwp9wjla663cm831zf0rc9361mvpn4imdsfz7hxs";
  };

  meta = with stdenv.lib; {
    description = "A collaborative terminal. In practice, it's similar to a shared screen or tmux session";
    homepage = "https://floobits.com/help/flootty";
    license = licenses.asl20;
    maintainers = with maintainers; [ sellout ];
  };
}
