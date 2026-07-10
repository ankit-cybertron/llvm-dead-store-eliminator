/*
 * real-world/input.c — Phase 4 validation input for the DSE pass.
 *
 * Compile to unoptimised IR then run the pass:
 *   clang -S -emit-llvm -O0 -Xclang -disable-O0-optnone -o input.ll input.c
 *   opt -load-pass-plugin=../build/libDSEPass.dylib \
 *       -passes=my-dse -S input.ll -o input_dse.ll
 *
 * (The -disable-O0-optnone flag prevents clang from marking every function
 *  optnone so that opt is actually allowed to transform them.)
 *
 * This file intentionally contains:
 *   1. Dead stores inside a single basic block (the pass WILL eliminate these)
 *   2. Stores guarded by a load (the pass MUST NOT eliminate these)
 *   3. Stores invalidated by a call (the pass MUST NOT eliminate these)
 *   4. Cross-block dead stores (the pass WILL NOT eliminate these in v1)
 */

#include <stdio.h>
#include <string.h>

/* -----------------------------------------------------------------------
 * Pattern A: back-to-back stores to the same local — classic dead store.
 * The pass should eliminate the first store to `result` in each case.
 * ----------------------------------------------------------------------- */
int compute_with_dead_init(int a, int b) {
    int result;
    result = 0;        /* dead: overwritten below before any read */
    result = a + b;
    return result;
}

int overwrite_twice(int x) {
    int buf;
    buf = -1;          /* dead */
    buf = 0;           /* dead */
    buf = x * 2;
    return buf;
}

/* -----------------------------------------------------------------------
 * Pattern B: store, load, store — first store is live (load reads it).
 * The pass must NOT eliminate the first store here.
 * ----------------------------------------------------------------------- */
int store_load_store(int val) {
    int tmp;
    tmp = val;         /* live: read by the printf below */
    printf("val=%d\n", tmp);
    tmp = val * 2;     /* this second store may or may not be dead */
    return tmp;
}

/* -----------------------------------------------------------------------
 * Pattern C: store before an unknown call — call may read the pointer,
 * so the pass conservatively keeps the store.
 * ----------------------------------------------------------------------- */
void store_then_call(int *out, int v) {
    *out = v;          /* conservative: next call may read *out */
    fflush(stdout);    /* unknown call — clears all tracking */
    *out = v + 1;
}

/* -----------------------------------------------------------------------
 * Pattern D: cross-block dead store (v1 cannot catch this; v2 will).
 * Both branches overwrite `x` before returning, so the entry-block store
 * is dead — but only detectable with MemorySSA.
 * ----------------------------------------------------------------------- */
int cross_block_dead(int cond, int a, int b) {
    int x;
    x = -999;          /* dead: both branches overwrite before any load */
    if (cond)
        x = a;
    else
        x = b;
    return x;
}

/* -----------------------------------------------------------------------
 * Pattern E: multiple locals, interleaved — tests that the map tracks
 * each pointer independently.
 * ----------------------------------------------------------------------- */
int multi_local(int p, int q) {
    int a, b;
    a = 0;             /* dead — overwritten before use */
    b = 0;             /* dead — overwritten before use */
    a = p + 1;
    b = q + 1;
    return a + b;
}

/* -----------------------------------------------------------------------
 * Pattern F: struct field stores (via member pointer).
 * getUnderlyingObject() should canonicalize GEPs to the struct alloca.
 * ----------------------------------------------------------------------- */
typedef struct { int x; int y; } Point;

int struct_dead_store(int px, int py) {
    Point pt;
    pt.x = 0;          /* dead: overwritten immediately */
    pt.x = px;
    pt.y = 0;          /* dead: overwritten immediately */
    pt.y = py;
    return pt.x + pt.y;
}
