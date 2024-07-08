package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import common.DBUtils;
import vo.MemberVO;
import vo.MoneyVO;

public class ThisDAO {
	
	public ArrayList<MemberVO> getListO(){
		ArrayList<MemberVO> list=  new ArrayList<MemberVO>();
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			con = DBUtils.getConnection();
			ps = con.prepareStatement(" select custno, custname, phone, address, to_char(joindate, 'YYYY-MM-DD') joindate, \r\n"
					+ "decode(grade, 'A','VIP','B','일반','C','직원') grade, city \r\n"
					+ "from member_2024_07");
			rs = ps.executeQuery();
			
			while(rs.next()) {
				MemberVO vo = new MemberVO();
				vo.setCustno(rs.getInt("custno"));
				vo.setCustname(rs.getString("custname"));
				vo.setPhone(rs.getString("phone"));
				vo.setAddress(rs.getString("address"));
				vo.setJoindate(rs.getDate("joindate"));
				vo.setGrade(rs.getString("grade"));
				vo.setCity(rs.getString("city"));
				list.add(vo);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	public ArrayList<MoneyVO> getListT(){
		ArrayList<MoneyVO> list = new ArrayList<MoneyVO>();
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			con = DBUtils.getConnection();
			ps = con.prepareStatement(" select A.custno, A.custname, \r\n"
					+ " decode(A.grade, 'A','VIP','B','일반','C','직원') as grade, \r\n"
					+ " sum(B.price) as price\r\n"
					+ "from member_2024_07 A, money_2024_07 B\r\n"
					+ "where A.custno = B.custno\r\n"
					+ "group by A.custno, A.custname, A.grade\r\n"
					+ "order by sum(B.price) desc");
			rs = ps.executeQuery();
			
			while(rs.next()) {
				MoneyVO vo = new MoneyVO();
				vo.setCustno(rs.getInt("custno"));
				vo.setCustname(rs.getString("custname"));
				vo.setGrade(rs.getString("grade"));
				vo.setPrice(rs.getInt("price"));
				list.add(vo);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	
	
	
	
	
}
