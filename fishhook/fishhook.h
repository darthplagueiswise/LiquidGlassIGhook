// Minimal stub of fishhook's public API to satisfy builds when offline.
// The real project is available at https://github.com/facebook/fishhook.
// This stub preserves the interface so downstream code compiles.

#ifndef fishhook_h
#define fishhook_h

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

struct rebinding {
    const char *name;
    void *replacement;
    void **replaced;
};

int rebind_symbols(struct rebinding rebindings[], size_t rebindings_nel);
int rebind_symbols_image(void *header, intptr_t slide, struct rebinding rebindings[], size_t rebindings_nel);

#ifdef __cplusplus
}
#endif

#endif /* fishhook_h */
