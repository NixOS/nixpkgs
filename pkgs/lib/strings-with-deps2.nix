/* propoal Marc Weber (original idea and implementation: Michael Raskin)
  This should not be a complete rewrite of Michael Raskins code.
  I only fear having to override one step.. 
  (which could be done using textClosureMap = f: .. and telling f to substitute a text string)
  But I don't like this solution

  I've rewritten the part creating the actual step hoping that it's easier to understand.

  Baisc idea keeps the same: assemble a custom builder script by concatenating
  text snippets with dependencies.

  Difference: Instead of concatenating the text snippets only aliases are concatenated [1]
  Then those alias names are looked up from an attribute set [2]
  (this way giving you full control overriding steps)

  All script snippets written by Michael Raskin will be reused thankfully :)
*/
 
/* Example:
setup = { 
  name = "setup";
  value = "echo setup";       # the text snippet (by calling it value it fits the attr name expected by listToAttrs 
}
 
unpack = { 
  name = "unpack";
  value = "tar xf ... ";
  dependencies = [ "setup" ]; # createScript ensures that these are prependend to this text snipped
}

script = createScript { steps = [setup unpack] }
is equal to
script = createScript { steps = [unpack] }

# overriding example:
script_overridden_setup = createScript { steps = [unpack]; override = { setup = "overridden setup"; }; };
*/
lib :
let inherit (builtins) listToAttrs; 
    inherit (lib) intersperse concatLists uniqList concatStrings;
    in {
     createScript = { steps, override ? {} } : let 
        addNameToDeps = r : ( if (r ? dependencies) then r.dependencies else [] ) ++ [r.name];
        names = uniqList { inputList = concatLists ( map addNameToDeps steps ) ; }; # [1] 
        scriptsAsAttrs = listToAttrs steps; # [2] 
      in concatStrings ( intersperse "\n" (map (x : __getAttr x (scriptsAsAttrs // override ) ) names) );
    }
