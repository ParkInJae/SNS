package sns.vo;

public class ComplainVO {

	private int cpno;	 // 기본키
	private int bno;	 // 외래키
	private int uno;	 // 외래키
	
	public int getCpno() {return cpno;}
	public int getBno() {return bno;}
	public int getUno() {return uno;}
	
	public void setCpno(int cpno) {this.cpno = cpno;}
	public void setBno(int bno) {this.bno = bno;}
	public void setUno(int uno) {this.uno = uno;}
	
	
	
}
