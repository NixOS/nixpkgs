{ lib }:

{
  pname = "musl";

  meta = with lib; {
    description = "Efficient, small, quality libc implementation";
    homepage = "https://musl.libc.org";
    license = licenses.mit;
    teams = [ teams.minimal-bootstrap ];
    platforms = platforms.unix;
  };
}
