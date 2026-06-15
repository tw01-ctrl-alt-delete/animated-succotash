    public partial class RabotaSZakazami : Window
    {
        public CompanyDBEntities db = new CompanyDBEntities();

        public RabotaSZakazami()
        {
            try
            {
                InitializeComponent();
                DGOrders.ItemsSource = db.Orders.ToList();

                CBZakazchik.ItemsSource = db.Customers.Select(c => c.CustomerName).Distinct().ToList();

                RefreshOrder();
		
		BTNFiltr.Click += (s, e) => RefreshOrders();
        	BTNSbrosFiltr.Click += (s, e) => { CBZakazchik.SelectedItem = null; TBSearch.Text = ""; RefreshOrders(); };
        	BTNSearch.Click += (s, e) => RefreshOrders();
                lbSort.SelectionChanged += (s, e) => RefreshOrder();
                rbSortVozr.Checked += (s, e) => RefreshOrder();
                rbSortUb.Checked += (s, e) => RefreshOrder();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при запуске приложения: {ex.Message}", "Критическая ошибка",
                                MessageBoxButton.OK, MessageBoxImage.Error);
                Application.Current.Shutdown();
            }


        }

        private void RefreshOrder()
        {
            IQueryable<Orders> query = db.Orders.Include("Customers");

            // Фильтр по заказчику
            if (CBZakazchik.SelectedItem != null)
            {
                string selectedName = CBZakazchik.SelectedItem.ToString();
                query = query.Where(o => o.Customers.CustomerName == selectedName);
            }

            // Поиск
            string searchText = TBSearch.Text;
            if (!string.IsNullOrEmpty(searchText))
            {
                query = query.Where(o =>
                    o.Customers.CustomerName.Contains(searchText) ||
                    o.Customers.Address.Contains(searchText) ||
                    o.Customers.Phone.Contains(searchText) ||
                    o.OrderDate.ToString().Contains(searchText) ||
                    o.TotalAmount.ToString().Contains(searchText)
                );
            }

            //Сортировка
            string sort = GetSelectedSortField(); // получаем выбранное поле
            bool isAscending = rbSortVozr.IsChecked == true;

            switch (sort)
            {
                case "Заказчик":
                    query = isAscending
                        ? query.OrderBy(o => o.Customers.CustomerName)
                        : query.OrderByDescending(o => o.Customers.CustomerName);
                    break;
                case "Дата заказа":
                    query = isAscending
                        ? query.OrderBy(o => o.OrderDate)
                        : query.OrderByDescending(o => o.OrderDate);
                    break;
                case "Сумма заказа":
                    query = isAscending
                        ? query.OrderBy(o => o.TotalAmount)
                        : query.OrderByDescending(o => o.TotalAmount);
                    break;
                default:
                    // Если ничего не выбрано, сортируем по умолчанию (например, по дате заказа)
                    query = query.OrderBy(o => o.OrderDate);
                    break;
            }



            DGOrders.ItemsSource = query.ToList();

            var list = query.ToList();
            DGOrders.ItemsSource = list;
            tbOrdersCount.Text = $"Всего заказов: {list.Count}";
            tbTotalSum.Text = $"Общая сумма: {list.Sum(o => o.TotalAmount):F2}";

        }

        

        // Вспомогательный метод для получения выбранного поля из ListBox
        private string GetSelectedSortField()
        {
            if (lbSort.SelectedItem is ListBoxItem selected)
                return selected.Content.ToString();
            return "Дата заказа"; // значение по умолчанию
        }
