module ApplicationHelper
  # Formats a monetary amount as Italian currency, e.g. 4.2 => "4,20 €".
  # Uses the number.currency format defined in config/locales/it.yml.
  def eur(amount)
    number_to_currency(amount || 0)
  end
end
