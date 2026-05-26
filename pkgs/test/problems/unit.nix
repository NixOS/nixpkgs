{ lib }:
let
  p = import ../../stdenv/generic/problems.nix { inherit lib; };

  genConstraintsTest = problems: expected: {
    expr = (p.genHandlerSwitch { inherit problems; }).definedConstraints;
    inherit expected;
  };

  genHandlerTest =
    let
      slowReference =
        config: kind: name: package:
        # Try to find an explicit handler
        (config.problems.handlers.${package} or { }).${name}
          # Fall back, iterating through the matchers
          or (lib.pipe config.problems.matchers [
            # Find matches
            (lib.filter (
              matcher:
              (matcher.name != null -> name == matcher.name)
              && (matcher.kind != null -> kind == matcher.kind)
              && (matcher.package != null -> package == matcher.package)
            ))
            # Extract handler level
            (map (matcher: matcher.handler))
            # Take the strongest matched handler level
            (lib.foldl' p.handlers.max "ignore")
          ]);

      genValue =
        f:
        map
          (
            package:
            map
              (
                name:
                map (kind: f kind name package) [
                  "k1"
                  "k2"
                  "k3"
                ]
              )
              [
                "n1"
                "n2"
                "n3"
              ]
          )
          [
            "p1"
            "p2"
            "p3"
          ];

    in
    v: {
      expr = genValue (p.genHandlerSwitch { problems = v; }).handlerForProblem;
      expected = genValue (slowReference {
        problems = v;
      });
    };
in
lib.runTests {
  testHandlersLessThan =
    let
      levels = p.handlers.levels;
      slowReference =
        a: b:
        lib.lists.findFirstIndex (v: v == a) (abort "Shouldn't happen") levels
        < lib.lists.findFirstIndex (v: v == b) (abort "Shouldn't happen") levels;

      genValue =
        f:
        lib.genList (
          i: lib.genList (j: f (lib.elemAt levels i) (lib.elemAt levels j)) (lib.length levels)
        ) (lib.length levels);
    in
    {
      expr = genValue p.handlers.lessThan;
      expected = genValue slowReference;
    };

  testHandlerEmpty = genHandlerTest {
    matchers = [ ];
    handlers = { };
  };

  testHandlerNameSpecificHandlers = genHandlerTest {
    matchers = [ ];
    handlers.p1.n1 = "error";
    handlers.p1.n2 = "warn";
    handlers.p1.n3 = "ignore";
  };

  testHandlerPackageSpecificHandlers = genHandlerTest {
    matchers = [ ];
    handlers.p1.n1 = "error";
    handlers.p2.n1 = "warn";
    handlers.p3.n1 = "ignore";
  };

  testHandlersOverrideMatchers = genHandlerTest {
    matchers = [
      {
        package = "p1";
        name = "n1";
        kind = null;
        handler = "error";
      }
    ];
    handlers.p1.n1 = "warn";
  };

  testMatchersDefault = genHandlerTest {
    matchers = [
      # Everything should warn by default
      {
        package = null;
        name = null;
        kind = null;
        handler = "warn";
      }
    ];
    handlers = { };
  };

  testMatchersComplicated = genHandlerTest {
    matchers = [
      {
        package = "p1";
        name = null;
        kind = null;
        handler = "warn";
      }
      {
        package = "p1";
        name = "n1";
        kind = null;
        handler = "error";
      }
      {
        package = "p1";
        name = null;
        kind = "k1";
        handler = "error";
      }
      {
        package = "p1";
        name = "n2";
        kind = "k2";
        handler = "error";
      }
    ];
    handlers = { };
  };

  testDefinedConstraintsEmpty =
    genConstraintsTest
      {
        matchers = [ ];
        handlers = { };
      }
      {
        kinds = [ ];
        names = [ ];
        packages = [ ];
      };

  testDefinedConstraintsMatchers =
    genConstraintsTest
      {
        handlers = { };
        matchers = [
          {
            package = null;
            name = null;
            kind = "k1";
            handler = "warn";
          }
          {
            package = null;
            name = null;
            kind = "k2";
            handler = "error";
          }
          {
            package = null;
            name = null;
            kind = "k3";
            handler = "ignore";
          }
          {
            package = "p1";
            name = "n1";
            kind = null;
            handler = "error";
          }
          {
            package = "p2";
            name = "n1";
            kind = null;
            handler = "warn";
          }
        ];
      }
      {
        kinds = [
          "k1"
          "k2"
        ];
        names = [ "n1" ];
        packages = [
          "p1"
          "p2"
        ];
      };

  testDefinedConstraintsHandlers =
    genConstraintsTest
      {
        matchers = [ ];
        handlers.p1.n1 = "warn";
        handlers.p1.n2 = "error";
        handlers.p2.n3 = "ignore";
      }
      {
        kinds = [ ];
        names = [
          "n1"
          "n2"
        ];
        packages = [
          "p1"
        ];
      };
}
