<html lang="pt-br">

<head>
    <meta charset="utf-8" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        /* Fundo da página */
        body {
            background-image: url(https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2023/07/10/dia-da-pizza-skkhweuqjcrq.jpg);
            background-repeat: no-repeat;
            background-size: cover;
            font-family: "Inter", sans-serif;
            margin: 0;
            padding-top: 120px;
        }

        /* Estilo do cabeçalho */
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

        /* Estilo do conteúdo principal */
        main {
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

        .card {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border: 2px solid black; /* A borda preta fina envolve tudo */
            border-radius: 10px;
            transition: transform 0.3s;
        }

        .card:hover {
            transform: scale(1.05);
        }

        /* Ajuste na imagem para não cortar e se ajustar corretamente */
        .card-img-top {
            max-height: 200px;
            object-fit: contain; /* Faz a imagem se ajustar sem ser cortada */
            border-radius: 10px 10px 0 0; /* Deixa o topo arredondado */
        }

        .card-body {
            background-color: transparent; /* Remove fundo branco */
            padding: 15px;
        }

        .card-title {
            color: #007bff;
        }

        .card-text {
            color: #555;
        }

        /* Estilo do botão */
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

        /* Ajuste para centralizar as pizzas mais para baixo */
        @media (max-width: 764px) {
            header {
                display: block;
                padding: 15px;
            }

            main {
                margin-top: 180px;
                padding: 15px;
            }

            header h1 img {
                width: 100px;
            }
        }

        /* Novo estilo para centralizar o conteúdo das pizzas */
        #imoveis {
            margin-top: 50px; /* Abaixando um pouco as pizzas */
        }

        .row {
            display: flex;
            justify-content: center; /* Centraliza as cartas horizontalmente */
        }

    </style>
</head>

<body>
    <header>
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

    <main class="container my-5">
        <h2>Lista de Pizzas</h2><br />
        <div id="imoveis" class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4"></div>
    </main>

    <script>
        function consultar() {
            var jsonEnvio = {};
            jsonEnvio.acao = "consultar";
            $.ajax({
                url: "PizzaServlet",
                data: jsonEnvio,
                type: "post",
                success: function (resp) {
                    var jsonVetor = JSON.parse(resp);
                    var linhas = "";

                    for (var i = 0; i < jsonVetor.length; i++) {
                        var pizza = jsonVetor[i];
                        linhas += `
                            <div class="col">
                                <div class="card">
                                    <img src="` + pizza.foto + `" class="card-img-top" alt="Pizza" />
                                    <div class="card-body">
                                        <h5 class="card-title">Sabor: ` + pizza.sabor + `</h5>
                                        <p class="card-text">Valor: R$ ` + pizza.valor + `</p>
                                    </div>
                                </div>
                            </div>
                        `;
                    }

                    document.getElementById("imoveis").innerHTML = linhas;
                },
                error: function () {
                    alert("Ocorreu um erro ao consultar!!!");
                }
            });
        }

        consultar();
    </script>
</body>

</html>
