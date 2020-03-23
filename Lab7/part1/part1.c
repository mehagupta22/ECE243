#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

volatile int pixel_buffer_start; // global variable
void clear_screen();
void draw_line(int start_x, int start_y, int end_x, int end_y, short int line_color);
void plot_pixel(int x, int y, short int line_color);
void swap(int * x, int * y);

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;

    // Read location of the pixel buffer from the pixel buffer controller 
    pixel_buffer_start = *pixel_ctrl_ptr;

    clear_screen();
    draw_line(0, 0, 150, 150, 0x001F);   // this line is blue
    draw_line(150, 150, 319, 0, 0x07E0); // this line is green
    draw_line(0, 239, 319, 239, 0xF800); // this line is red
    draw_line(319, 0, 0, 239, 0xF81F);   // this line is a pink color
}

// clear_screen subroutine
void clear_screen()
{
	int x, y;
	for(x = 0; x <= 319; ++x){
		for(y = 0; y <= 239; ++y){
			plot_pixel(x, y, 0x0000);
		}
	}

}

// draw_line subroutine
void draw_line(int start_x, int start_y, int end_x, int end_y, short int line_color)
{
	bool is_steep = abs(start_y - end_y) > abs(start_x - end_x);
	if(is_steep){
		swap(&start_x, &start_y);
		swap(&end_x, &end_y);
	}
	if (start_x > end_x){
		swap(&start_x, &end_x);
		swap(&start_y, &end_y);
	}
	
	int delta_x = end_x - start_x;
	int delta_y = abs(end_y - start_y);
	int error = -(delta_x/2);
	int y = start_y;
	int y_step;
	if(start_y < end_y) y_step = 1;
	else y_step = -1;
	
	for(int x = start_x; x <= end_x; ++x){
		if(is_steep) plot_pixel(y, x, line_color);
		else plot_pixel(x, y, line_color);
		error = error + delta_y;
		if(error >= 0){
			y = y + y_step;
			error = error - delta_x;
		}
	}	
}


void plot_pixel(int x, int y, short int line_color)
{
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}

void swap(int * x, int * y){
	int temp = *x;
    *x = *y;
    *y = temp;   
}
