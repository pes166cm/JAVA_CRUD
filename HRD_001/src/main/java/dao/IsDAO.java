package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import common.DBUtils;
import vo.CandidateVO;
import vo.RankVO;
import vo.VoteListVo;
import vo.VoteVO;

public class IsDAO {
	
	public ArrayList<CandidateVO> getCandidateList() {
		ArrayList<CandidateVO> list = new ArrayList<CandidateVO>();
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			con = DBUtils.getConnection();
			ps = con.prepareStatement(" select A.c_no, A.c_name, B.p_name,\r\n"
					+ "decode(A.c_school, '1', '고졸', '2', '학사', '3', '석사', '4', '박사') c_school,\r\n"
					+ "substr(A.c_jumin, 1, 6) || '-' || substr(a.c_jumin, 7, 7) c_jumin,\r\n"
					+ "A.c_city, B.p_tel1 || '-' || B.p_tel2 || '-' || B.p_tel3 tel \r\n"
					+ "from T3_CANDIDATE A, T3_PARTY B\r\n"
					+ "where A.p_code = B.p_code order by A.p_code");
			
			rs = ps.executeQuery();
			
			while(rs.next()){
				CandidateVO vo = new CandidateVO();
				
				vo.setC_no(rs.getString("c_no"));
				vo.setC_name(rs.getString("c_name"));
				vo.setP_name(rs.getString("p_name"));
				vo.setC_school(rs.getString("c_school"));
				vo.setC_jumin(rs.getString("c_jumin"));
				vo.setC_city(rs.getString("c_city"));
				vo.setTel(rs.getString("tel"));
				list.add(vo);
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return list;
	}
	
	public int castVote(VoteVO vo) {
		int n = 0;
		
		Connection con = null;
		PreparedStatement ps = null;
		
		try {
			con = DBUtils.getConnection();
			ps = con.prepareStatement(" insert into t3_vote values(?,?,?,?,?,?)");
			ps.setString(1, vo.getV_jumin());
			ps.setString(2, vo.getV_name());
			ps.setString(3, vo.getC_no());
			ps.setString(4, vo.getV_time());
			ps.setString(5, vo.getV_area());
			ps.setString(6, vo.getV_confirm());
			
			n = ps.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return n;
	}
	
	public ArrayList<VoteListVo> getVoteList(){
		ArrayList<VoteListVo> list = new ArrayList<VoteListVo>();
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			con = DBUtils.getConnection();
			ps = con.prepareStatement(" select v_name, "
					+ "'19' || substr(v_jumin,1,2)||'년'||substr(v_jumin,3,2)||'월'||substr(v_jumin,5,2)||'일' birth,\r\n"
					+ "'만'||(2024-(to_number('19'||substr(v_jumin,1,2))))||'세' age,\r\n"
					+ "decode(substr(v_jumin,7,1),'1', '남', '2', '여') genter,\r\n"
					+ "c_no, substr(v_time,1,2)||':'||substr(v_time,3,2) v_time,\r\n"
					+ "decode(v_confirm,'Y', '확인', 'N', '미확인') v_confirm\r\n"
					+ "from t3_vote");
			
			rs = ps.executeQuery();
			while(rs.next()) {
				VoteListVo vo = new VoteListVo();
				vo.setV_name(rs.getString("v_name"));
				vo.setBirth(rs.getString("birth"));
				vo.setAge(rs.getString("age"));
				vo.setGenter(rs.getString("genter"));
				vo.setC_no(rs.getString("v_name"));
				vo.setV_time(rs.getString("v_time"));
				vo.setV_confirm(rs.getString("v_confirm"));
				list.add(vo);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<RankVO> rankList(){
		ArrayList<RankVO> list = new ArrayList<RankVO>();
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			con = DBUtils.getConnection();
			ps = con.prepareStatement(" select A.c_no, B.c_name, C.p_name, \r\n"
					+ "count(A.c_no) total, rank() over(order by count(A.c_no) desc) rank\r\n"
					+ "from t3_vote A, t3_candidate B, T3_PARTY C\r\n"
					+ "where A.c_no = B.c_no and B.p_code = C.p_code and A.v_confirm = 'Y'\r\n"
					+ "group by A.c_no, B.c_name, C.p_name order by rank");
			rs = ps.executeQuery();
			while(rs.next()) {
				RankVO vo = new RankVO();
				vo.setC_no(rs.getString("c_no"));
				vo.setC_name(rs.getString("c_name"));
				vo.setP_name(rs.getString("p_name"));
				vo.setTotal(rs.getInt("total"));
				vo.setRank(rs.getInt("rank"));
				list.add(vo);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}
