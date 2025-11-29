import { Component } from "@angular/core";
import { CommonModule } from "@angular/common";
import { FormsModule } from "@angular/forms";
import { Router, RouterModule } from "@angular/router";
import { MatButtonModule } from "@angular/material/button";
import { MatInputModule } from "@angular/material/input";
import { MatFormFieldModule } from "@angular/material/form-field";
import { MatIconModule } from "@angular/material/icon";
import { MatProgressSpinnerModule } from "@angular/material/progress-spinner";
import { SupabaseService } from "../../services/supabase.service";

@Component({
  selector: "app-register",
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
    MatButtonModule,
    MatInputModule,
    MatFormFieldModule,
    MatIconModule,
    MatProgressSpinnerModule,
  ],
  templateUrl: "./register.component.html",
  styleUrls: ["./register.component.css"],
})
export class RegisterComponent {
  email = "";
  password = "";
  confirmPassword = "";
  loading = false;
  hidePassword = true;
  hideConfirmPassword = true;

  constructor(private supabase: SupabaseService, private router: Router) {}

  async onRegister() {
    if (!this.email || !this.password || !this.confirmPassword) {
      alert("Por favor, preencha todos os campos!");
      return;
    }

    if (this.password !== this.confirmPassword) {
      alert("As senhas não coincidem!");
      return;
    }

    if (this.password.length < 6) {
      alert("A senha deve ter no mínimo 6 caracteres!");
      return;
    }

    this.loading = true;
    try {
      await this.supabase.register(this.email, this.password);
      alert(
        "Cadastro realizado com sucesso! Verifique seu email para confirmar."
      );
      this.router.navigate(["/login"]);
    } catch (err: any) {
      console.error("Erro ao cadastrar:", err);
      alert(err.message || "Erro ao realizar cadastro!");
    } finally {
      this.loading = false;
    }
  }
}
