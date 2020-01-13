package ca.uhn.fhir.jpa.starter;

import ca.uhn.fhir.rest.api.server.RequestDetails;
import ca.uhn.fhir.rest.server.exceptions.BaseServerResponseException;
import ca.uhn.fhir.rest.server.interceptor.consent.ConsentOutcome;
import ca.uhn.fhir.rest.server.interceptor.consent.IConsentContextServices;
import ca.uhn.fhir.rest.server.interceptor.consent.IConsentService;
import org.hl7.fhir.instance.model.api.IBaseCoding;
import org.hl7.fhir.instance.model.api.IBaseResource;

import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;
import java.util.regex.Pattern;

public class SecurityLabelConsentService implements IConsentService {
  private static final org.slf4j.Logger ourLog = org.slf4j.LoggerFactory.getLogger(SecurityLabelConsentService.class);

  @Override
  public ConsentOutcome startOperation(RequestDetails requestDetails, IConsentContextServices iConsentContextServices) {
    Pattern whitespace = Pattern.compile("\\s+");
    String authText = requestDetails.getHeader("Authorization");
    String[] authHeader = whitespace.split(authText, 2);
    if (authHeader.length < 2) {
      //ourLog.info("Rejecting because authorization \"" + authText + "\" had only " + authHeader.length + " fields" );
      return ConsentOutcome.REJECT;
    } else if (!authHeader[0].equals("Bearer")) {
      //ourLog.info("Rejecting because authorization \"" + authText + "\" started with " + authHeader[0] +
      //  " instead of Bearer");
      return ConsentOutcome.REJECT;
    } else if (authHeader[1].equals("Admin")) {
      //ourLog.info("Accepting Admin Access!");
      return ConsentOutcome.AUTHORIZED;
    }
    return ConsentOutcome.PROCEED;
  }

  @Override
  public ConsentOutcome canSeeResource(RequestDetails requestDetails, IBaseResource iBaseResource, IConsentContextServices iConsentContextServices) {
    Pattern whitespace = Pattern.compile("\\s+");
    String[] authHeader = whitespace.split(requestDetails.getHeader("Authorization"), 2);
    if (authHeader.length < 2 || !authHeader[0].equals("Bearer")) {
      return ConsentOutcome.REJECT;
    } else if (authHeader[1] == "Admin") {
      return ConsentOutcome.AUTHORIZED;
    }

    String[] permissions = whitespace.split(authHeader[1]);

    Predicate<IBaseCoding> hasPermissions =
      (IBaseCoding c) -> Arrays.stream(permissions).anyMatch(c.getCode()::equals);
    if (iBaseResource.getMeta().getSecurity().stream().anyMatch(hasPermissions)) {
      return ConsentOutcome.AUTHORIZED;
    } else {
      return ConsentOutcome.REJECT;
    }
  }

  @Override
  public ConsentOutcome willSeeResource(RequestDetails requestDetails, IBaseResource iBaseResource, IConsentContextServices iConsentContextServices) {
    return ConsentOutcome.AUTHORIZED;
  }

  @Override
  public void completeOperationSuccess(RequestDetails requestDetails, IConsentContextServices iConsentContextServices) {
    // Could add logging here
  }

  @Override
  public void completeOperationFailure(RequestDetails requestDetails, BaseServerResponseException e, IConsentContextServices iConsentContextServices) {
    // Could add logging here
  }
}
