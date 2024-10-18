#include <malloc.h>
#include <errno.h>

int posix_memalign (void **memptr, size_t alignment, size_t size) {
    *memptr = memalign(alignment, size);
    if (*memptr == NULL) {
        return ENOMEM;
    }
    return 0;
}
