package io.mosip.kernel.core.util;

import org.springframework.context.annotation.Bean;

import brave.sampler.Sampler;

public class DistributedTracingUtils {

		@Bean
		public Sampler defaultSampler() {
			return Sampler.ALWAYS_SAMPLE;
		}
}
