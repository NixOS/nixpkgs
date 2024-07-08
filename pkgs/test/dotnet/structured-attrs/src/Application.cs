using System;
using System.Reflection;

Console.Write(
    (
        (AssemblyCopyrightAttribute)Assembly
            .GetExecutingAssembly()
            .GetCustomAttributes(typeof(AssemblyCopyrightAttribute), true)[0]
    ).Copyright
);
