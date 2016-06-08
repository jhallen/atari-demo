#include <stdlib.h>
#include <stdio.h>
#include <math.h>

int line[200]; /* Number of dots on each line */
int dot[200][160];

int anymore(int y)
{
    for (y = y + 1; y != 200; ++y)
        if (line[y])
            return 1;
    return 0;
}

main()
{
    int x, y, z;
    int ary[200];
    int blk;
    int prev = -1;

    /* Sin tables */

    printf("offtab\n");
    for (x = 0; x != 256; ++x) {
        double y = 80.0 + 79.0*sin(2.0*M_PI*(double)x/256.0);
        printf("	.byte	$%2.2x\n", (int)y >> 2);
    }

    printf("bittab\n");
    for (x = 0; x != 256; ++x) {
        double y = 80.0 + 79.0*sin(2.0*M_PI*(double)x/256.0);
        printf("	.byte	$%2.2x\n", 1 << (2 * (3 - ((int)y & 0x03))));
    }

    /* Make 256 random dots */
    for (z = 0; z != 200; ++z) {
        y = rand() % 200;
        x = rand() % 256;
        dot[y][line[y]] = x;
        ++line[y];
    }

    /* Emit code for each line */
    blk = 0;
    printf("xorit\n");
    for (y = 0; y != 200; ++y) {
        if (line[y]) {
            int addr = 0x4010 + y * 40;
            printf("	lda	#$%2.2x\n", 255 & addr);
            printf("	sta	addr\n");
            if (prev != (addr >> 8)) {
                printf("	lda	#$%2.2x\n", addr >> 8);
                printf("	sta	addr+1\n");
                prev = (addr >> 8);
            }
            for (x = 0; x != line[y]; ++x) {
                printf("	lda	#$%2.2x ; X coord\n", dot[y][x]);
                if (x + 1 != line[y] || anymore(y))
                    printf("	jsr	draw\n", y);
            }
        }
    }

    return 0;
}
