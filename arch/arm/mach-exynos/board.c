#include <common.h>
#include <config.h>
#include <asm/io.h>

int led_debug=0;

void s_init(void)
{
	writel(readl(0x1002330c) | 0x300, 0x1002330c);
	writel(0, 0x11000c08);

	/* led test */
	//led_test();
}

void led0_test(void)
{
	/* GPK1_1 */
	writel(0x10, 0x11000060);
	writel(0x0, 0x11000064);

	/* GPL2_0 */
	writel(0x1, 0x11000100);
	writel(0x0, 0x11000104);
}

void led1_test(void)
{
	/* GPK1_1 */
	writel(0x10, 0x11000060);
	writel(0x2, 0x11000064);

	/* GPL2_0 */
	writel(0x1, 0x11000100);
	writel(0x0, 0x11000104);
}
void led2_test(void)
{
	/* GPK1_1 */
	writel(0x10, 0x11000060);
	writel(0x0, 0x11000064);

	/* GPL2_0 */
	writel(0x1, 0x11000100);
	writel(0x1, 0x11000104);
}
void led_test(void)
{
	/* GPK1_1 */
	writel(0x10, 0x11000060);
	writel(0x2, 0x11000064);

	/* GPL2_0 */
	writel(0x1, 0x11000100);
	writel(0x1, 0x11000104);
}
