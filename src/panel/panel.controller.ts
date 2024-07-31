import { Controller, Post,Get, Body, Param } from '@nestjs/common';
import { PanelService } from './panel.service';
import { IpAddress } from '../comics/ip-address.decorator'; // Import the decorator

@Controller('panel')
export class PanelController {
  constructor(private readonly panelService: PanelService) {}

  @Post('add-text')
  async addTextToImage(
    @Body('imageUrl') imageUrl: string,
    @Body('outputImagePath') outputImagePath: string,
    @Body('text') text: string[],
    @IpAddress() ipAddress: string
  ): Promise<void> {
    await this.panelService.addTextToImage(text, imageUrl, outputImagePath, ipAddress);
  }
  @Get('remaining-tries')
  async getRemainingTries(@IpAddress() ipAddress: string): Promise<{ remainingTries: number }> {
    const count = await this.panelService.getComicGenerationCount(ipAddress);
    const remainingTries = Math.max(0, 3 - count);
    return { remainingTries };
  }  
}
