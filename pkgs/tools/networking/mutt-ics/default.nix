{ lib, python3, fetchPypi }:

with python3.pkgs; buildPythonApplication rec {
  pname = "mutt-ics";
  version = "0.9.2";

  src = fetchPypi {
    inherit version;
    pname = "mutt_ics";
    hash = "sha256-1E1L7E5xx/FN8BuQ/blWPNx4Ts5CUKv+pbC2dc/oWlA=";
  };

  propagatedBuildInputs = [ icalendar ];

  meta = with lib; {
    homepage = "https://github.com/dmedvinsky/mutt-ics";
    description = "Tool to show calendar event details in Mutt";
    mainProgram = "mutt-ics";
    license = licenses.mit;
    maintainers = with maintainers; [ mh182 ];
  };
}
