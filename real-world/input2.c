#include <stdint.h>

/* A: Nested struct via pointer arg — 4 dead stores expected */
typedef struct { int x; int y; } Vec2;
typedef struct { Vec2 pos; Vec2 vel; } Entity;

void entity_reset(Entity *e, int px, int py, int vx, int vy) {
    e->pos.x = -1;  e->pos.x = px;
    e->pos.y = -1;  e->pos.y = py;
    e->vel.x = -1;  e->vel.x = vx;
    e->vel.y = -1;  e->vel.y = vy;
}

/* B: Constant-index array — 4 dead stores expected */
int array_const_idx(void) {
    int arr[4];
    arr[0] = 0;  arr[1] = 0;  arr[2] = 0;  arr[3] = 0;
    arr[0] = 10; arr[1] = 20; arr[2] = 30; arr[3] = 40;
    return arr[0] + arr[1] + arr[2] + arr[3];
}

/* C: Out-parameter double-write — 2 dead stores expected */
void fill_coords(int *x_out, int *y_out, int x, int y) {
    *x_out = -1;
    *y_out = -1;
    *x_out = x;
    *y_out = y;
}

/* D: Chained re-assignments — 2 dead stores expected */
int chained(int a, int b) {
    int x;
    x = 0;
    x = -1;
    x = a + b;
    return x;
}

/* E: Signal-processing stats reset — 4 dead stores expected */
typedef struct { float mean; float variance; float peak; int count; } Stats;

void stats_reset(Stats *s, float m, float v, float p, int c) {
    s->mean = 0.0f;      s->mean     = m;
    s->variance = 0.0f;  s->variance = v;
    s->peak = 0.0f;      s->peak     = p;
    s->count = 0;        s->count    = c;
}

/* F: Cross-block early return — 0 expected (v1 limitation) */
int safe_divide(int num, int den) {
    int result = 0;
    if (den == 0)
        return -1;
    result = num / den;
    return result;
}

/* G: Volatile writes — 0 expected (correctly skipped) */
void write_hw_reg(volatile uint32_t *reg, uint32_t val) {
    *reg = 0xDEAD;
    *reg = val;
}

/* H: Variable-index array loop — 0 expected (non-const GEP) */
void init_array(int *arr, int n) {
    for (int i = 0; i < n; i++) {
        arr[i] = 0;
        arr[i] = i;
    }
}

/* I: Many dead-initialized locals — 4 dead stores expected */
int compute_all(int a, int b, int c, int d) {
    int p, q, r, s;
    p = 0; q = 0; r = 0; s = 0;
    p = a * 2;
    q = b * 3;
    r = p + q;
    s = r - c * d;
    return s;
}

/* J: Store-load-store — 0 expected (first store is live) */
int store_load_store(int x, int y) {
    int tmp;
    tmp = x;
    int saved = tmp + 1;
    tmp = y;
    return tmp + saved;
}
