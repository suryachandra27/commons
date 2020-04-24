package io.mosip.kernel.core.security.util;

import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.SSLContext;
import java.io.File;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;

@Configuration
public class SSLConfig {

	@Autowired
	private Environment environment;

	@Bean
	public RestTemplate restTemplateConfig()
			throws KeyManagementException, NoSuchAlgorithmException, KeyStoreException {

		//TrustStrategy acceptingTrustStrategy = (X509Certificate[] chain, String authType) -> true;

		SSLContext sslContext =null;
		 try {
			sslContext = new SSLContextBuilder()
					.loadKeyMaterial(new
									File(environment.getProperty("server.ssl.key-store")),
							environment.getProperty("server.ssl.key-store-password").toCharArray(),
							environment.getProperty("server.ssl.key-password").toCharArray())
					.loadTrustMaterial(new
									File(environment.getProperty("server.ssl.trust-store")),
							environment.getProperty("server.ssl.trust-store-password").toCharArray())
					.build();
		} catch (CertificateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (UnrecoverableKeyException e) {
			e.printStackTrace();
		}
		 SSLConnectionSocketFactory csf = new SSLConnectionSocketFactory(sslContext);
		/*SSLConnectionSocketFactory csf = new SSLConnectionSocketFactory(sslContext, new String[] { "TLSv1.2" }, null,
				SSLConnectionSocketFactory.
						ALLOW_ALL_HOSTNAME_VERIFIER);
								//getDefaultHostnameVerifier());
*/
		CloseableHttpClient httpClient = HttpClients.custom().setSSLSocketFactory(csf).build();
		HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory();

		requestFactory.setHttpClient(httpClient);
		return new RestTemplate(requestFactory);

	}

}
