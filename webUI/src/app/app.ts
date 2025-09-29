import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { MatSidenavModule } from '@angular/material/sidenav';
import {HeaderComponent} from './components/layout/header/header';
import {SidenavComponent} from './components/layout/sidenav/sidenav';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet,
    MatSidenavModule,
    HeaderComponent,
    SidenavComponent],
  templateUrl: './app.html',
  standalone: true,
  styleUrl: './app.scss'
})
export class App {
  protected readonly title = signal('webUI');
}
