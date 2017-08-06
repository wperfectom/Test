/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.venta.lib;

import java.io.*;
import java.util.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
//import org.apache.tomcat.dbcp.dbcp.ConnectionFactory;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;


public class SQLCommander1 {
	private static String sDriver="";
	private static String sURL="";
	private static String sUsuario="";
	private static String sClave="";

	private static PropertyResourceBundle propiedades;

	static{
		try
		{
       String sRuta=System.getProperty("user.dir");
       System.out.println(sRuta);
      // propiedades = new PropertyResourceBundle(new FileInputStream(sRuta+"/connectSQL.properties"));
       propiedades = new PropertyResourceBundle(new FileInputStream(sRuta+"/connectOracle.properties"));
     	sDriver= propiedades.getString("DRIVER");
	    sURL= propiedades.getString("URL");
	    sUsuario= propiedades.getString("USUARIO");
	    sClave= propiedades.getString("CLAVE");
         System.out.println("Driver :"+sDriver);
		}
		catch(Exception e){
				System.out.println(e);
			}
	    }

	public static Connection obtieneConexion() throws NamingException,SQLException{

		Connection cn=null;

		/*Context ctx = new InitialContext();
                DataSource ds=(DataSource) ctx.lookup("java:comp/env/jdbc/TestDB");
                Connection cn=ds.getConnection();*/

		try{
		  	Class.forName(sDriver);
          	cn=DriverManager.getConnection(sURL,sUsuario,sClave);
            //cn.setCatalog("Tienda2009");
		}
		catch(Exception e){
			//System.out.println(e);
                    e.printStackTrace();
		}

		return cn;
	}
}


