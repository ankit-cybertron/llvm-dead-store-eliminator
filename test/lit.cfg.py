import os
import lit.formats

config.name = "LLVM Dead Store Eliminator"
config.test_format = lit.formats.ShTest(True)
config.suffixes = [".ll"]
config.test_source_root = os.path.dirname(__file__)
config.test_exec_root = os.path.join(config.test_source_root, "Output")

# Path to the built plugin. Override at invocation time with:
#   lit -Ddse_lib=/path/to/libDSEPass.dylib test/
lib_path = lit_config.params.get(
    "dse_lib",
    os.path.join(config.test_source_root, "..", "build", "libDSEPass.dylib"),
)
config.substitutions.append(("%dse_lib", lib_path))

# `opt` must be on PATH (e.g. via `brew --prefix llvm`/bin, or add it to
# your shell profile). We just pass it through as-is.
config.substitutions.append(("opt", "opt"))
