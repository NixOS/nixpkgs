{ lib, python3 }:

with python3.pkgs; buildPythonApplication rec {
  pname = "mutt-ics";
  version = "0.9.2";

  src = fetchPypi {
    inherit version;
    pname = "mutt_ics";
    sha256 = "d44d4bec4e71c7f14df01b90fdb9563cdc784ece4250abfea5b0b675cfe85a50";
  };

  propagatedBuildInputs = [ icalendar ];

  meta = with lib; {
    homepage = "https://github.com/dmedvinsky/mutt-ics";
    description = "A tool to show calendar event details in Mutt";
    license = licenses.mit;
    maintainers = with maintainers; [ mh182 ];
  };
}
