// Ghidra post-analysis script run by tests/headless-analysis.nix. It emits
// NIX_TEST_* markers that the surrounding derivation greps for. Running it
// exercises the parts of a native Ghidra build that "does the GUI launch" does
// not: the processor's Sleigh specification and the native decompiler process.
//
// Written in Java rather than Python: Ghidra 12 dropped bundled Jython, and
// Python scripts now require the PyGhidra runtime, which the package does not
// ship. Java scripts are compiled in-process by analyzeHeadless with no extra
// runtime. The class name must match the file name.
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionManager;
import ghidra.program.model.listing.Listing;
import ghidra.util.task.ConsoleTaskMonitor;

public class CheckAnalysis extends GhidraScript {
    @Override
    public void run() throws Exception {
        FunctionManager fm = currentProgram.getFunctionManager();
        Listing listing = currentProgram.getListing();

        Function marker = null;
        for (Function f : fm.getFunctions(true)) {
            // Mach-O prefixes C symbols with an underscore, while ELF does not.
            if (f.getName().equals("nix_ghidra_marker") ||
                f.getName().equals("_nix_ghidra_marker")) {
                marker = f;
            }
        }

        println("NIX_TEST_ARCH=" + currentProgram.getLanguageID().getIdAsString());
        println("NIX_TEST_INSTRS=" + listing.getNumInstructions());
        println("NIX_TEST_HASMARKER=" + (marker != null ? 1 : 0));

        // Decompile the marker function. This spawns the native decompiler
        // binary, which is the component that was previously cross-built for the
        // wrong architecture on aarch64-darwin.
        int declen = 0;
        if (marker != null) {
            DecompInterface ifc = new DecompInterface();
            ifc.openProgram(currentProgram);
            DecompileResults res = ifc.decompileFunction(marker, 60, new ConsoleTaskMonitor());
            if (res.decompileCompleted() && res.getDecompiledFunction() != null) {
                String c = res.getDecompiledFunction().getC();
                declen = c == null ? 0 : c.length();
            }
        }
        println("NIX_TEST_DECOMPILED_LEN=" + declen);
    }
}
