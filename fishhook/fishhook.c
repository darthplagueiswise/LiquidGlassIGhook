#include "fishhook.h"

int rebind_symbols(struct rebinding rebindings[], size_t rebindings_nel) {
    (void)rebindings;
    (void)rebindings_nel;
    return 0;
}

int rebind_symbols_image(void *header, intptr_t slide, struct rebinding rebindings[], size_t rebindings_nel) {
    (void)header;
    (void)slide;
    (void)rebindings;
    (void)rebindings_nel;
    return 0;
}
