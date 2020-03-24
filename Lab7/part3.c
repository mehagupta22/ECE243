#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

volatile int pixel_buffer_start; // global variable
void clear_screen();
void draw_box(int x, int y, short int box_color);
void draw_line(int start_x, int start_y, int end_x, int end_y, short int line_color);
void plot_pixel(int x, int y, short int line_color);
void swap(int * x, int * y);
void wait_for_vsync();

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
	
	// Variables required
	int N = 8;
	short int color[10] = {0x001F,0x07E0,0xF800,0xF81F,0xBf3eff,0x07E0,0xF81F,0x07E0,0xF81F,0xF81F};
	short int box_color[N];
	int dx_box[N], dy_box[N], x_box[N], y_box[N];
	for(int i = 0; i < N; i++){
		box_color[i] = color[(rand() % 10)];
		dx_box[i] = ((rand() % 2)*2) - 1;
		dy_box[i] = ((rand() % 2)*2) - 1;
		x_box[i] = rand() % 320;
		y_box[i] = rand() % 240;	
	}

    /* set front pixel buffer to start of FPGA On-chip memory */
    *(pixel_ctrl_ptr + 1) = 0xC8000000; // first store the address in the 
                                        // back buffer
    /* now, swap the front/back buffers, to set the front buffer location */
    wait_for_vsync();
    /* initialize a pointer to the pixel buffer, used by drawing functions */
    pixel_buffer_start = *pixel_ctrl_ptr;
    clear_screen(); // pixel_buffer_start points to the pixel buffer
    /* set back pixel buffer to start of SDRAM memory */
    *(pixel_ctrl_ptr + 1) = 0xC0000000;
    pixel_buffer_start = *(pixel_ctrl_ptr + 1); // we draw on the back buffer

    while (1)
    {
		/* Erase any boxes and lines that were drawn in the last iteration */
        clear_screen();
		
        // code for drawing the boxes and lines (not shown)
		for(int i = 0; i < N; i++){
			//drawing 2 x 2 boxes and the lines connecting them
			draw_box(x_box[i], y_box[i], box_color[i]);
			draw_line(x_box[i], y_box[i], x_box[(i+1)%N], y_box[(i+1)%N], box_color[i]);
			
			x_box[i] = x_box[i] + dx_box[i];
			y_box[i] = y_box[i] + dy_box[i];
			if(x_box[i] == 0 || x_box[i] == 319) dx_box[i] = -dx_box[i];
			if(y_box[i] == 0 || y_box[i] == 239) dx_box[i] = -dy_box[i];
		}
		
        wait_for_vsync(); // swap front and back buffers on VGA vertical sync
        pixel_buffer_start = *(pixel_ctrl_ptr + 1); // new back buffer
    }
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

//draw_box subroutine
void draw_box(int x, int y, short int box_color){
	plot_pixel(x, y, box_color);
	plot_pixel(x + 1, y, box_color);
	plot_pixel(x + 2, y, box_color);
	plot_pixel(x, y + 1, box_color);
	plot_pixel(x + 1, y + 2, box_color);
	plot_pixel(x + 2, y + 1, box_color);
	plot_pixel(x, y + 2, box_color);
	plot_pixel(x + 1, y + 1, box_color);
	plot_pixel(x + 2, y + 2, box_color);
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

//plot_pixel subroutine
void plot_pixel(int x, int y, short int line_color)
{
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}

//swap subroutine
void swap(int * x, int * y){
	int temp = *x;
    *x = *y;
    *y = temp;   
}

//wait for VGA sync subroutine
void wait_for_vsync(){
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    register int status;
    
    *pixel_ctrl_ptr = 1;
    status = *(pixel_ctrl_ptr + 3);
    
    while((status & 0x01) != 0){
        status = *(pixel_ctrl_ptr + 3);
    }
}