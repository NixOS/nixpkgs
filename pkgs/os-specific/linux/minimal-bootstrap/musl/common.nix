{ lib }:

{
  pname = "musl";

<<<<<<< HEAD
  meta = {
    description = "Efficient, small, quality libc implementation";
    homepage = "https://musl.libc.org";
    license = lib.licenses.mit;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Efficient, small, quality libc implementation";
    homepage = "https://musl.libc.org";
    license = licenses.mit;
    teams = [ teams.minimal-bootstrap ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
