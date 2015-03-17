package org.jboss.demos.simpledemo;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

@Path("/")
public class SettingsRestService {
	
	private Map<String,String> settingsMap = new HashMap<String,String>(); 
	
	public SettingsRestService() {
		String hostname = this.getHostname();
		settingsMap.put("hostname", hostname);
		settingsMap.put("os", String.format("%1$s-%3$s (%2$s)", System.getProperty("os.name"),System.getProperty("os.arch"),System.getProperty("os.version")));
	}
	
	@GET
    @Path("settings")
    @Produces({ "application/json" })
    public Map<String,String> getSettings() throws IOException {
        return settingsMap;
    }

	/**
	 * This demo app is designed to run in a docker container, hence we could assume linux, but to be able to test the code, we added support for windows and Mac OS X also. 
	 * @return
	 * @throws IOException 
	 */
	private String getHostname() {
		String OS = System.getProperty("os.name");
		if (OS.indexOf("win") >= 0) {
            return System.getenv("COMPUTERNAME");
        } else if (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("Mac OS")>=0 ) {
        	try {
        		BufferedReader reader = new BufferedReader(new InputStreamReader(Runtime.getRuntime().exec("hostname").getInputStream()));
				return reader.readLine();
			} catch (IOException e) {
				
				e.printStackTrace();
				return "Failed to get from native hostname command";
			}
        }
        else {
        	return "Unknown";
        }
	}
}
