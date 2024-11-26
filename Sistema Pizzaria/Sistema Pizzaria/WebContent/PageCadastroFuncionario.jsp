<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html lang="pt-br">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cadastro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

    <style>
        body {
            background-image: url(https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2023/07/10/dia-da-pizza-skkhweuqjcrq.jpg);
            background-repeat: no-repeat;
            background-size: cover;
            font-family: "Inter", sans-serif;
            margin: 0;
            padding-top: 120px;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #120e0d;
            color: white;
            padding: 20px;
            position: absolute;
            width: 100%;
            top: 0;
            z-index: 10;
        }

        header h1 img {
            width: 120px;
            height: auto;
        }

        nav ul {
            display: flex;
            list-style: none;
            padding: 0;
        }

        nav ul li {
            margin-left: 20px;
        }

        nav ul li a {
            text-decoration: none;
            color: white;
            font-size: 16px;
            background-color: #ed1c0d;
            padding: 10px 20px;
            border-radius: 5px;
        }

        nav ul li a:hover {
            background-color: #f99b1c;
        }

        .container {
            background-color: rgba(0, 0, 0, 0.7);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            margin-top: 120px;
            z-index: 5;
        }

        h2 {
            color: white;
            text-align: center;
            margin-bottom: 20px;
        }

        label {
            color: white;
            margin-bottom: 10px;
        }

        input {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
        }

        .btn-primary {
            background-color: #ed1c0d;
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
        }

        .btn-primary:hover {
            background-color: #f99b1c;
        }

        .btn-secondary {
            color: #fff;
            background-color: #120e0d;
            padding: 10px 20px;
            border-radius: 5px;
        }

        .btn-secondary:hover {
            background-color: #f99b1c;
        }

        .pecaJa {
            color: white;
            font-size: 16px;
            text-align: center;
            padding: 10px;
            position: absolute;
            bottom: 30px;
            width: 100%;
            left: 0;
        }

        @media (max-width: 764px) {
            header {
                display: block;
                padding: 15px;
            }

            .container {
                margin-top: 180px;
                padding: 15px;
            }

            input {
                padding: 10px;
            }

            .pecaJa {
                font-size: 14px;
            }

            header h1 img {
                width: 100px;
            }
        }
    </style>
</head>
<body>

<header class="Homepage">
    <h1><img src="src/imagens/domRamon.png" alt="Logo da Pizzaria"></h1>
    <nav>
        <ul class="list-unstyled d-flex">
                <li><a href="PageHome.jsp" class="btn btn-primary"><i class="bi bi-list"></i> Menu</a></li>
                <li><a href="PageCadastroFuncionario.jsp" class="btn btn-primary"><i class="bi bi-list"></i> Cadastro</a></li>
                <li><a href="PageLogin.jsp" class="btn btn-primary"><i class="bi bi-list"></i> Login</a></li>
        </ul>
    </nav>
    <div class="pecaJa">
        <i class="bi bi-whatsapp"> Peça Já (11) 98868-5856</i>
    </div>
</header>

<main>
    <div class="container text-left">
        <div class="row justify-content-center">
            <div class="col-8">
                <h2 class="mb-4">Cadastro</h2>

                <label for="nome" class="form-label">Nome</label>
                <input type="text" class="form-control mb-3" id="nome" placeholder="Digite seu nome" />

                <label for="email" class="form-label">E-mail</label>
                <input type="text" class="form-control mb-3" id="email" placeholder="Digite seu e-mail" />

                <label for="senha" class="form-label">Senha</label>
                <input type="password" class="form-control mb-3" id="senha" placeholder="Digite sua senha" />

                <label for="confirmaSenha" class="form-label">Confirmar Senha</label>
                <input type="password" class="form-control mb-3" id="confirmaSenha" placeholder="Confirmar sua senha" />

                <br>
                <button type="button" class="btn btn-primary" onclick="concluirCadastro()">Concluir Cadastro</button>
                <br><br>
                
                <a href="PageLogin.jsp" class="btn btn-secondary">Já tenho conta</a>
            </div>
        </div>
    </div>
</main>

<script type="text/javascript">
    function concluirCadastro() {
        var nome = document.getElementById("nome").value;
        var email = document.getElementById("email").value;
        var senha = document.getElementById("senha").value;
        var confirmaSenha = document.getElementById("confirmaSenha").value;

        // Verificação se as senhas coincidem
        if (senha !== confirmaSenha) {
            alert("As senhas não coincidem. Por favor, tente novamente.");
            return;
        }

        // Enviar os dados do formulário para o servidor via AJAX ou outro método
        var jsonEnvio = {
            nome: nome,
            email: email,
            senha: senha,
            acao: "inserir"
        };

        $.ajax({
            url: "FuncionarioServlet", // URL para o processamento do cadastro
            data: jsonEnvio,
            type: "POST",
            success: function (resp) {
                if (resp === "ok") {
                    alert("Cadastro realizado com sucesso!");
                    window.location.href = "PageLogin.jsp?email=" + encodeURIComponent(email);
                } else {
                    alert("Erro no cadastro: " + resp);
                }
            },
            error: function () {
                alert("Ocorreu um erro ao cadastrar. Tente novamente.");
            }
        });
    }
</script>

</body>
</html>
