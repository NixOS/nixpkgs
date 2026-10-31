{
  lib,
  newScope,
}:

let
  outer = lib.makeScope newScope (self: {
  });
in
outer
