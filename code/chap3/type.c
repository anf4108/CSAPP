#define src_t char
#define dest_t short

void test(src_t *sp, dest_t *dp) {
    *dp = (dest_t)*sp;
}