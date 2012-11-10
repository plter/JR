package
{
	import com.plter.jr.client.ValueObject;
	
	
	public class MyVO extends ValueObject
	{
		public function MyVO()
		{
			this.alias="MyVO";
		}
		
		public var myVO1:MyVO1;
		
		public var data:String="http://plter.com";
	}
}