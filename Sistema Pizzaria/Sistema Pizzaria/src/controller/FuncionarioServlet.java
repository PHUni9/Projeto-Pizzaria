package controller;

import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class FuncionarioServlet
 */
@WebServlet("/FuncionarioServlet")
public class FuncionarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public FuncionarioServlet() {
        super();
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("utf-8");
        String acao = request.getParameter("acao");
        try {
            if ("login".equals(acao)) {
                login(request, response);
            } else if ("logout".equals(acao)) {
                logout(request, response);
            } else if ("consultar".equals(acao)) {
                consultar(request, response);
            } else if ("inserir".equals(acao)) {
                inserir(request, response);
            } else if ("alterar".equals(acao)) {
                alterar(request, response);
            } else if ("excluir".equals(acao)) {
                excluir(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().append("Ocorreu um erro na solicitação para " + acao);
        }
    }

    public Connection getConection() throws Exception {
        Connection conn = null;
        Class.forName("org.sqlite.JDBC");
        String diretorio = System.getProperty("wtp.deploy").toString().split(".metadata")[0];
        String dataBase = diretorio + "\\pizzaria.db";
        conn = DriverManager.getConnection("jdbc:sqlite:" + dataBase);
        return conn;
    }

    // Logout
    public void logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(true);
        session.invalidate();
        response.getWriter().append("ok");
    }

    // Login
    public void login(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        MessageDigest md = MessageDigest.getInstance("MD5");
        BigInteger hash = new BigInteger(1, md.digest(senha.getBytes()));
        senha = hash.toString(16); // Transformando a senha em hash

        Connection conn = getConection();
        String sql = "select * from funcionario where email=? and senha=?";
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, email);
        pstm.setString(2, senha);
        ResultSet rs = pstm.executeQuery();
        if (rs.next()) {
            response.getWriter().append("ok");
            HttpSession session = request.getSession(true);
            session.setAttribute("nome", rs.getString(3));
        } else {
            response.getWriter().append("erro");
            HttpSession session = request.getSession(true);
            session.invalidate();
        }
        conn.close();
    }

    // Consultar todos os funcionários
    public void consultar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=utf-8");
        Connection conn = getConection();
        String sql = "select * from funcionario";
        PreparedStatement pstm = conn.prepareStatement(sql);
        ResultSet rs = pstm.executeQuery();
        StringBuilder tabelaHtml = new StringBuilder();

        while (rs.next()) {
            String col1 = "<td><img src='src/imagens/edit.png' onclick='editar(" + rs.getInt(1) + ",\"" + rs.getString(2) + "\",\"" + rs.getString(3) + "\")'/></td>";
            String col2 = "<td><img src='src/imagens/delete.png' onclick='confirmarExcluir(" + rs.getInt(1) + ")'/></td>";
            String col3 = "<td>" + rs.getInt(1) + "</td>"; // matrícula
            String col4 = "<td>" + rs.getString(2) + "</td>"; // email
            String col5 = "<td>" + rs.getString(3) + "</td>"; // nome
            String linha = "<tr>" + col1 + col2 + col3 + col4 + col5 + "</tr>";
            tabelaHtml.append(linha);
        }

        response.getWriter().append(tabelaHtml.toString());
        conn.close();
    }

    // Inserir funcionário
    public void inserir(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String email = request.getParameter("email");
        String nome = request.getParameter("nome");
        String senha = request.getParameter("senha");

        MessageDigest md = MessageDigest.getInstance("MD5");
        BigInteger hash = new BigInteger(1, md.digest(senha.getBytes()));
        senha = hash.toString(16); // Transformando a senha em hash

        Connection conn = getConection();
        String sql = "insert into funcionario(email, nome, senha) values(?, ?, ?)";
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, email);
        pstm.setString(2, nome);
        pstm.setString(3, senha);
        int qtdAfetadas = pstm.executeUpdate();

        if (qtdAfetadas > 0) {
            response.getWriter().append("ok");
        } else {
            response.getWriter().append("Não foi possível inserir!");
        }
        conn.close();
    }

    // Alterar dados do funcionário
    public void alterar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int matricula = Integer.parseInt(request.getParameter("matricula"));
        String email = request.getParameter("email");
        String nome = request.getParameter("nome");
        String senha = request.getParameter("senha");

        MessageDigest md = MessageDigest.getInstance("MD5");
        BigInteger hash = new BigInteger(1, md.digest(senha.getBytes()));
        senha = hash.toString(16); // Transformando a senha em hash

        Connection conn = getConection();
        String sql = "update funcionario set email=?, nome=?, senha=? where matricula=?";
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setString(1, email);
        pstm.setString(2, nome);
        pstm.setString(3, senha);
        pstm.setInt(4, matricula);
        int qtdAfetadas = pstm.executeUpdate();

        if (qtdAfetadas > 0) {
            response.getWriter().append("Dados alterados com sucesso!");
        } else {
            response.getWriter().append("Não foi possível alterar!");
        }
        conn.close();
    }

    // Excluir funcionário
    public void excluir(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int matricula = Integer.parseInt(request.getParameter("matricula"));
        Connection conn = getConection();
        String sql = "delete from funcionario where matricula=?";
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, matricula);
        int qtdAfetadas = pstm.executeUpdate();

        if (qtdAfetadas > 0) {
            response.getWriter().append("Funcionário excluído com sucesso!");
        } else {
            response.getWriter().append("Não foi possível excluir o funcionário!");
        }
        conn.close();
    }
}
