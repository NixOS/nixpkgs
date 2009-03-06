let lib = import ./default.nix; in

rec {


  # Wrapper aroung the primop `addErrorContext', which shouldn't used
  # directly.  It evaluates and returns `val', but if an evaluation
  # error occurs, the text in `msg' is added to the error context
  # (stack trace) printed by Nix.
  addErrorContext =
    if builtins ? addErrorContext
    then builtins.addErrorContext
    else msg: val: val;

  addErrorContextToAttrs = lib.mapAttrs (a : v : lib.addErrorContext "while evaluating ${a}" v);


}