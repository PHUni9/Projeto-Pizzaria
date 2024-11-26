<%@ include file="Protecao.jsp" %>

<%
    String nome = (String) session.getAttribute("nome");
%>

<html lang="pt-br">

<head>
    <meta charset="utf-8"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <style>
        /* Fundo da página cinza escuro */
        body {
            background-color: #333; /* Cinza escuro */
            color: white;
            font-family: "Inter", sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh; /* Ocupa toda a altura da página */
            margin: 0;
            text-align: center;
        }

        /* Estilo do container */
        .container {
            background-color: rgba(0, 0, 0, 0.8); /* Fundo translúcido */
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            width: 80%;
            max-width: 600px;
        }

        h2 {
            color: white; /* Cor branca para o texto "Seja bem-vindo" */
            font-size: 28px;
            margin-bottom: 20px;
        }

        .nome {
            color: #007bff; /* Cor azul para o nome */
            font-weight: bold; /* Deixa o nome em negrito */
        }

        p {
            font-size: 18px;
            margin-bottom: 30px;
        }

        .btn {
            background-color: #ed1c0d; /* Cor do botão */
            border: none;
            color: white;
            font-size: 16px;
            padding: 12px 25px;
            margin: 10px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            background-color: #f99b1c; /* Cor do botão ao passar o mouse */
            transition: background-color 0.3s;
        }

        input[type="button"] {
            background-color: #ed1c0d; /* Cor do botão */
            border: none;
            color: white;
            font-size: 16px;
            padding: 12px 25px;
            margin: 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        input[type="button"]:hover {
            background-color: #f99b1c;
            transition: background-color 0.3s;
        }

        /* Melhorias para dispositivos menores */
        @media (max-width: 768px) {
            h2 {
                font-size: 24px;
            }

            p {
                font-size: 16px;
            }

            .btn,
            input[type="button"] {
                padding: 10px 20px;
                font-size: 14px;
            }
        }
    </style>
</head>

<body>

    <div class="container">
        <h2>Seja bem-vindo, <span class="nome"><%= nome %></span>!</h2>
        <p>Escolha uma das opções abaixo para gerenciar:</p>

        <!-- Botões para redirecionamento -->
        <a href="PageGerenciarFuncionario.jsp">
            <input type="button" value="Gerenciar Funcionários"/>
        </a><br /><br />

        <a href="PageGerenciarPizzas.jsp">
            <input type="button" value="Gerenciar Pizzas"/>
        </a><br /><br />

        <!-- Botão de logout -->
        <input type="button" onclick="fazer_logout()" value="Sair"/>
    </div>

    <script>
        function fazer_logout(){
            var jsonEnvio = {};
            jsonEnvio.acao  = "logout";
            $.ajax({
                url:"FuncionarioServlet",
                data: jsonEnvio,
                type: "post",
                success: function (resp){
                    if (resp=="ok"){
                        document.location.href="PageLogin.jsp";
                    }else{
                        alert("Ocorreu um erro ao realizar o logout!")
                    }
                }
            });
        }
    </script>

</body>

</html>
