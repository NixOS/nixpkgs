{ lib }:

{
  pname = "musl";

  meta = with lib; {
    description = "An efficient, small, quality libc implementation";
    homepage = "https://musl.libc.org";
    license = licenses.mit;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
}
